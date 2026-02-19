REPORT zztest.

TABLES: eanl.

* selezione (filtro)
SELECT-OPTIONS impianti FOR eanl-anlage.

* 1. Definiamo la struttura con più campi
TYPES: BEGIN OF ty_output,
         " 0. Business partner
         partner            TYPE but000-partner,
         cognome            TYPE but000-name_last,
         nome               TYPE but000-name_first,
         indirizzo_completo TYPE adrc-street,
         " 1. Edificio
         vstelle            TYPE eanl-vstelle,    " EDIFICIO
         "2. Conto contrattuale
         vkont              TYPE fkkvkp-vkont,    "conto contrattuale (tabella fkkvkp)
         "3. Contratto
         vertrag            TYPE ever-vertrag,    " Numero contratto
*         bukrs     TYPE ever-bukrs,      " società
         "4. Impianto + dettagli
         anlage             TYPE eanl-anlage,     " Numero impianto
*         sparte    TYPE eanl-sparte,     " Settore (divisione)
         anlart             TYPE eanl-anlart,     " tipo impianto
         text_imp           TYPE te439t-text30, " testo tipo impianto
         erdat              TYPE eanl-erdat,      " Data creazione (opzionale)
         "5. Apparecchiatura
         equipment          TYPE equi-equnr, "chiave della tabella contatori
         n_serie            TYPE equi-sernr, " valore che mi serve (numero di serie cic0)
         fine_val2          TYPE egerh-bis, "filtro apparecchiatura attualmente install


       END OF ty_output.
* 2. Tabella interna basata su questa struttura
DATA: lt_risultato TYPE STANDARD TABLE OF ty_output WITH EMPTY KEY.

* esegui
START-OF-SELECTION.

  SELECT
         b~partner,
         b~name_last AS cognome,
         b~name_first AS nome,
         ( ad~street && ' ' && ad~house_num1 ) AS indirizzo_completo,
         e~vstelle,
         f~vkont,
         c~vertrag,
*         c~bukrs,
         e~anlage,
*         e~sparte,
         e~anlart,
         te~text30 AS text_imp, "USO DOMESTICO RESIDENTE -> nell'impianto
         e~erdat,
         eq~equnr AS equipment,
         eq~sernr AS n_serie,
         eg~bis AS fine_val2"filtro su data per apparecchiatura att installata



  FROM eanl AS e                      " tabella impianti
  LEFT OUTER JOIN ever AS c
    ON c~anlage = e~anlage

  LEFT OUTER JOIN fkkvkp AS f         " tabella dati contrattuali del partner
    ON f~vkont = c~vkonto

  LEFT OUTER JOIN but000 AS b         " tabella business partner
    ON b~partner = f~gpart

* vado a recuperare l'apparecchiatura collegandomi all'impianto con le varie join
* PARTO DA EANL -> EASTL -> EGERH -> EQUI -> recupero il numero appar SERNR con chiave equipment EQUNR
  LEFT OUTER JOIN eastl AS ea
    ON ea~anlage = e~anlage
  LEFT OUTER JOIN egerh AS eg
    ON eg~logiknr = ea~logiknr
    AND eg~bis = '99991231' "filtro su data appar installata attualmente
  LEFT OUTER JOIN equi AS eq
    ON eq~equnr = eg~equnr

* vado a prendermi il testo del tipo impianto, ad esempio uso domestico residente ecc...
  INNER JOIN te439t AS te
    ON te~anlart = e~anlart
    AND te~spras = @sy-langu

* vado a prendermi l'indirizzo del bp
  INNER JOIN but020 AS but
  ON but~partner = b~partner
  INNER JOIN adrc AS ad
  ON ad~addrnumber = but~addrnumber

WHERE  e~anlage IN @impianti "filtra in base a cosa ho scritto in selezione
*  INTO TABLE @lt_risultato
  INTO CORRESPONDING FIELDS OF TABLE @lt_risultato "mi permette di non essere per forza allineato alla types con la select
UP TO 10 ROWS.

* output / visualizzazione
  IF lt_risultato IS NOT INITIAL.

    TRY.
        cl_salv_table=>factory(
      IMPORTING
      r_salv_table = DATA(gr_salv_table)
      CHANGING
      t_table = lt_risultato ).

* cambio nomi colonne come preferisco
        DATA(lo_columns) = gr_salv_table->get_columns( ).

        DATA(lo_column) = lo_columns->get_column( 'ANLAGE' ).
        lo_column->set_short_text( 'Imp.' ).
        lo_column->set_medium_text( 'Impianto' ).
        lo_column->set_long_text( 'Num. Impianto' ).

        " In maiuscolo il passaggio parametro sennò va in DUMP
        DATA(lo_column_indirizzo) = lo_columns->get_column( 'INDIRIZZO_COMPLETO' ).
        lo_column_indirizzo->set_medium_text( 'Indirizzo completo' ).



* ottimizzo la dimensione delle colonne in base al contenuto
        lo_columns->set_optimize( abap_true ).

* mostro griglia
        gr_salv_table->display( ).


      CATCH cx_salv_msg INTO DATA(lx_salv).
        MESSAGE lx_salv->get_text( ) TYPE 'I' DISPLAY LIKE 'E'.
    ENDTRY.

  ELSE.
    " Se la tabella è vuota, mostra un messaggio di errore in basso a sinistra
    MESSAGE 'Nessun dato trovato per i criteri inseriti' TYPE 'S' DISPLAY LIKE 'E'.
  ENDIF.
