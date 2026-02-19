REPORT zztest. " Nome del programma

* Dichiarazione della tabella del database per permettere al SELECT-OPTIONS
* di conoscere il tipo di dati del campo anlage
TABLES: eanl.

* --- INPUT UTENTE ---
* Crea un campo di selezione per l'Impianto (Anlage).
* Permette intervalli (DA... A...), valori singoli o inclusioni/esclusioni.
SELECT-OPTIONS IMPIANT2 FOR eanl-anlage.

* --- INIZIO LOGICA DI ELABORAZIONE ---
* Questo evento scatta quando l'utente preme F8 (Esegui)
START-OF-SELECTION.

  " Estrazione dati con JOIN tra EANL (Dati Impianto) e EVER (Contratti)
  SELECT e~anlage,   " Prende il numero impianto da EANL
         e~sparte,   " Prende il settore merceologico da EANL
         v~vertrag,  " Prende il numero contratto da EVER
         v~vbez,     " Prende la descrizione contratto da EVER
         v~einzdat   " Prende la data inizio contratto da EVER
    FROM eanl AS e   " Alias 'e' per la tabella EANL
    INNER JOIN ever AS v ON e~anlage = v~anlage " Lega le tabelle dove l'impianto è uguale
    WHERE e~anlage IN @IMPIANT2                 " Filtra in base a cosa ha scritto l'utente
      AND ( e~sparte = 'H1' OR e~sparte = 'IN' ) " Filtra solo per determinati settori
    INTO TABLE @DATA(lt_risultato)               " Crea al volo una tabella interna con i risultati
    UP TO 100 ROWS.                              " Limita la ricerca ai primi 100 record per performance

  " --- OUTPUT (VISUALIZZAZIONE) ---
  " Controlla se la tabella interna lt_risultato contiene almeno una riga
  IF lt_risultato IS NOT INITIAL.

    " Chiama il metodo 'factory' per preparare l'oggetto griglia (ALV)
    " IMPORTING r_salv_table: riceve l'oggetto creato nella variabile gr_salv_table
    " CHANGING t_table: collega la tua tabella dati alla griglia
    cl_salv_table=>factory(
      IMPORTING
        r_salv_table = DATA(gr_salv_table)
      CHANGING
        t_table      = lt_risultato ).

    " Attiva le funzioni standard della griglia (bottoni per Filtri, Ordinamento, Export Excel)
     gr_salv_table->get_functions( )->set_all( abap_true ).


  " 1. EFFETTO ZEBRA (Righe colorate alternate)
  DATA(lo_display) = gr_salv_table->get_display_settings( ).
  lo_display->set_striped_pattern( abap_true ).

  " 2. CAMBIARE TITOLI DELLE COLONNE
  " Recupero l'oggetto che gestisce tutte le colonne
  DATA(lo_columns) = gr_salv_table->get_columns( ).
  lo_columns->set_optimize( abap_true ). " Stringe le colonne in base al contenuto

  TRY.
      " Recupero la singola colonna 'ANLAGE'
      DATA(lo_column) = lo_columns->get_column( 'ANLAGE' ).

      " Cambio i testi (Lungo, Medio, Corto) - si adatta quando allarghi la colonna
      lo_column->set_long_text( 'Codice Impianto' ).
      lo_column->set_medium_text( 'Cod. Impianto' ).
      lo_column->set_short_text( 'Imp' ).

    CATCH cx_salv_not_found. " Gestione errore se la colonna non esiste
  ENDTRY.

    " Mostra effettivamente la griglia a video
    gr_salv_table->display( ).

  ELSE.
    " Se la tabella è vuota, mostra un messaggio di errore in basso a sinistra
    MESSAGE 'Nessun dato trovato per i criteri inseriti' TYPE 'S' DISPLAY LIKE 'E'.
  ENDIF.