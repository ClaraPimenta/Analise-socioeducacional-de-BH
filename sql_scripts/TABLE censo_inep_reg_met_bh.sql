DROP TABLE IF EXISTS b_inep.censo_inep_reg_met_bh cascade;

CREATE TABLE "b_inep"."censo_inep_reg_met_bh" AS
SELECT
  	meb."CO_ENTIDADE",
  	meb."NO_ENTIDADE",
  	meb."CO_MUNICIPIO",
  	meb."NO_BAIRRO",
  	regexp_replace(lower(unaccent(meb."NO_BAIRRO")), '\s+', ' ', 'g')::text AS "bairro_norm",
  	meb."TP_DEPENDENCIA",
  	meb."TP_SITUACAO_FUNCIONAMENTO",
	meb."QT_MAT_BAS",
    meb."QT_MAT_BAS_0_3",
    meb."QT_MAT_BAS_4_5",
    meb."QT_MAT_BAS_6_10",
    meb."QT_MAT_BAS_11_14",
    meb."QT_MAT_BAS_15_17",
    meb."QT_MAT_BAS_18_MAIS",
    meb."QT_MAT_INF",
  	meb."QT_MAT_FUND",
  	meb."QT_MAT_MED"
FROM
    "b_inep"."microdados_ed_basica" AS "meb"
WHERE
    "meb"."CO_MUNICIPIO" IN (
        SELECT DISTINCT "CD_MUN"
        FROM "b_censo_ibge"."cod_bairros_br"
        WHERE "CD_MUN" IN (
            '3106200'
        )
    );
