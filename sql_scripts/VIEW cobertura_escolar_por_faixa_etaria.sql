-- Remove a VIEW se ela já existir, para garantir uma recriação limpa e sem erros.
DROP VIEW IF EXISTS cruzamentos.cobertura_escolar_por_faixa_etaria;

-- Cria a VIEW final que une os dados do IBGE e do INEP para calcular os indicadores de cobertura.
CREATE VIEW cruzamentos.cobertura_escolar_por_faixa_etaria AS
SELECT
    -- Colunas de identificação e socioeconômicas da tabela do IBGE
    ibge."bairro_norm",
    ibge."CD_MUN",
    ibge."NM_BAIRRO",
    ibge."CD_BAIRRO", -- Adicionando CD_BAIRRO para chaves futuras
    ibge."renda_per_capita",
    
    -- População em Idade Escolar (Denominadores)
    ibge."V01006" AS "populacao_total",
    ibge."V01031" AS "pop_0_a_4_anos",
    (ibge."V01032" + ibge."V01033") AS "pop_5_a_14_anos",
    ibge."V01034" AS "pop_15_a_19_anos",

    -- Matrículas por Nível (Numeradores), vindas da VIEW agregada do INEP
    inep."mat_infantil",
    inep."mat_fundamental",
    inep."mat_medio",
    inep."num_escolas", -- Incluindo o número de escolas para contexto
    inep."num_escolas_priv",
    inep."num_escolas_pub",
    inep."mat_total_priv",
    inep."mat_total_pub",

    -- --- INDICADORES DE COBERTURA (TAXAS) ---

    -- 1. Taxa de Cobertura da Educação Infantil
    ROUND(
        COALESCE(inep."mat_infantil", 0)::numeric /
        NULLIF(ibge."V01031", 0)::numeric,
        4
    ) AS "taxa_cobertura_infantil",

    -- 2. Taxa de Cobertura do Ensino Fundamental
    ROUND(
        COALESCE(inep."mat_fundamental", 0)::numeric /
        NULLIF((ibge."V01032" + ibge."V01033"), 0)::numeric,
        4
    ) AS "taxa_cobertura_fundamental",

    -- 3. Taxa de Cobertura do Ensino Médio
    ROUND(
        COALESCE(inep."mat_medio", 0)::numeric /
        NULLIF(ibge."V01034", 0)::numeric,
        4
    ) AS "taxa_cobertura_medio"

FROM 
    "b_censo_ibge"."bairros_reg_met_bh" AS ibge
LEFT JOIN 
    cruzamentos.dados_inep_agregados AS inep
    ON ibge."bairro_norm" = inep."bairro_norm"
    AND ibge."CD_MUN" = inep."CO_MUNICIPIO";