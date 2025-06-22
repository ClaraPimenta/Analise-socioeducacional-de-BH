DROP VIEW IF EXISTS cruzamentos.dados_inep_agregados;

CREATE VIEW cruzamentos.dados_inep_agregados AS
SELECT
    "bairro_norm",
    "CO_MUNICIPIO",
    
    COUNT(*) AS "num_escolas",
    
    SUM(CASE WHEN "TP_DEPENDENCIA" = 4 THEN 1 ELSE 0 END) AS "num_escolas_priv",
    SUM(CASE WHEN "TP_DEPENDENCIA" IN (1, 2, 3) THEN 1 ELSE 0 END) AS "num_escolas_pub",

    SUM("QT_MAT_BAS") AS "mat_total_basica",
    SUM("QT_MAT_BAS_0_3" + "QT_MAT_BAS_4_5") AS "mat_infantil",
    SUM("QT_MAT_BAS_6_10" + "QT_MAT_BAS_11_14") AS "mat_fundamental",
    SUM("QT_MAT_MED") AS "mat_medio",

    SUM(CASE WHEN "TP_DEPENDENCIA" = 4 THEN "QT_MAT_BAS" ELSE 0 END) AS "mat_total_priv",
    SUM(CASE WHEN "TP_DEPENDENCIA" IN (1, 2, 3) THEN "QT_MAT_BAS" ELSE 0 END) AS "mat_total_pub"

FROM
    "b_inep"."censo_inep_reg_met_bh"
WHERE
    "TP_SITUACAO_FUNCIONAMENTO" = 1
GROUP BY
    "bairro_norm",
    "CO_MUNICIPIO";
