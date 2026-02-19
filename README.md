# ISU-Installation-Device-Report

> ABAP IS-U extraction tool for integrated data visualization.

---

### [0] OVERVIEW
Report ABAP per estrazione e visualizzazione integrata di:
- **Impianto**           : EANL
- **Contratto**           : EVER
- **Conto contrattuale**  : FKKVKP / VKONT
- **Business Partner**    : BUT000 + ADRC (via/civico)
- **Apparecchiatura**     : EASTL -> EGERH -> EQUI

Display: Grid SALV (auto-optimized column width).

---

### [1] FEATURES
- Multi-selection su `ANLAGE`.
- Master data BP (Name, Surname, Full Address).
- Mapping `TE439T` per descrizioni tipi impianto.
- Filter: `BISZEITSCH = '99991231'` (Current Install).
- ALV SALV output con header custom.

---

### [2] DATA_STRUCTURE

| Tabella | Descrizione |
| :--- | :--- |
| EANL | Installazioni / Impianti |
| EVER | Contratti |
| FKKVKP | Dati partner / VKONT |
| BUT000 | Business Partner Header |
| BUT020 | BP -> Address Link |
| ADRC | Addresses (Street/City) |
| EASTL | Device Installation |
| EGERH | Device Master History |
| EQUI | Equipment (Serial NR) |
| TE439T | Plant Type Texts |

---

### [3] REQUIREMENTS
- ENVIRONMENT : SAP IS-U / EDM Active
- AUTH        : Table access (EANL, EVER, BUT000, etc.)
- STACK       : ABAP 7.40+ (Inline data, @HostVars, &&)

---

### [4] USAGE
1. Input `ANLAGE` range.
2. Execute `(F8)`.
3. Review optimized SALV grid.

---

[!] DISCLAIMER: Tool creato per analisi e debugging. Not a production-ready program.
