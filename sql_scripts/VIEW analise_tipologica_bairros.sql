-- Remove a VIEW se ela já existir, para garantir uma recriação limpa.
DROP VIEW IF EXISTS cruzamentos.analise_tipologia_bairros;

-- Cria a VIEW final que classifica cada bairro em uma tipologia socioeducacional.
CREATE VIEW cruzamentos.analise_tipologia_bairros AS
-- Utiliza uma Expressão de Tabela Comum (CTE) para calcular a renda média da região.
WITH media_renda AS (
    SELECT AVG("renda_per_capita") AS media_geral_renda
    FROM cruzamentos.cobertura_escolar_por_faixa_etaria
    WHERE "populacao_total" >= 2000 -- Calcula a média apenas dos bairros relevantes.
)
SELECT
    -- Seleciona as colunas da view anterior para mantê-las no resultado.
    b."bairro_norm",
    b."CD_MUN",
    b."NM_BAIRRO",
    b."CD_BAIRRO",
    b."renda_per_capita",
    b."populacao_total",
    b."taxa_cobertura_infantil",
    b."taxa_cobertura_fundamental",
    b."taxa_cobertura_medio",
    b."num_escolas",
    b."num_escolas_priv",
    b."mat_total_priv",
    b."mat_total_pub",

    -- A instrução CASE classifica cada bairro com base nas regras refinadas.
CASE
        -- 1. População insuficiente para análise.
        WHEN b."populacao_total" < 2000 THEN
            'População Insuficiente'

        -- 2. Polo Educacional: Forte no fundamental E médio.
        WHEN b."taxa_cobertura_fundamental" > 1.2 OR b."taxa_cobertura_medio" > 1.2 THEN
            'Polo Educacional'
        
        -- 3. Polo de Educação Básica (Forte no infantil e/ou fundamental).
        WHEN b."taxa_cobertura_infantil" > 1.2 OR b."taxa_cobertura_fundamental" > 1.2 THEN
            'Polo de Educação Básica'

        -- 4. Desertos Educacionais: Baixa renda e baixa cobertura geral.
        WHEN b."renda_per_capita" < (SELECT media_geral_renda FROM media_renda) AND
             (b."taxa_cobertura_infantil" < 0.8 AND b."taxa_cobertura_fundamental" < 0.8 AND b."taxa_cobertura_medio" < 0.8) THEN
            'Deserto Educacional'
            
        -- 5. Bairros Exportadores: Alta renda e baixa cobertura geral.
        WHEN b."renda_per_capita" >= (SELECT media_geral_renda FROM media_renda) AND
             (b."taxa_cobertura_infantil" < 0.8 AND b."taxa_cobertura_fundamental" < 0.8 AND b."taxa_cobertura_medio" < 0.8) THEN
            'Bairro Exportador'
            
        -- 6. Equilibrados (os demais casos).
        ELSE
            'Equilibrado'
            
    END AS "categoria_bairro"
FROM
    cruzamentos.cobertura_escolar_por_faixa_etaria AS b;