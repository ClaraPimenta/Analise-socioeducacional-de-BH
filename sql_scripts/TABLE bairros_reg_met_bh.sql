DROP TABLE IF EXISTS "bairros_reg_met_bh" cascade;

CREATE TABLE "bairros_reg_met_bh" AS
select
	bd."CD_BAIRRO",
    bd."NM_BAIRRO",
    cb."CD_MUN",
    regexp_replace(lower(unaccent(bd."NM_BAIRRO")), '\s+', ' ', 'g')::text AS "bairro_norm",
    CASE
        WHEN br."V06001" <> 0 AND br."V06002" <> 0 THEN
            br."V06004" / (br."V06002"::double precision / br."V06001"::double precision)
        ELSE NULL
    END AS "renda_per_capita",
    bd."V01006",
    bd."V01031",
    bd."V01032",
    bd."V01033",
    bd."V01034"
FROM
    "bairros_demografia" AS bd
JOIN "cod_bairros_br" AS cb ON bd."CD_BAIRRO" = cb."CD_BAIRRO"
JOIN "bairros_renda" AS br ON bd."CD_BAIRRO" = br."CD_BAIRRO"
WHERE
    cb."CD_MUN" IN (
        '3106200'
    );