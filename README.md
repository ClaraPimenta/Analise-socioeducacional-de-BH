# Analise-socioeducacional-de-BH

## 1. Visão Geral e Foco do Projeto

Este projeto utiliza um Banco de Dados para realizar integração e análise de conjuntos de dados públicos. O foco central do trabalho é a utilização do PostgreSQL para processar e transformar dados brutos do Censo Demográfico (IBGE) e do Censo Escolar (INEP) em uma base de dados analítica e coesa.

Como resultado final desta pipeline de dados, foi desenvolvida uma análise que classifica os bairros de Belo Horizonte em diferentes tipologias socioeducacionais, revelando padrões de desigualdade e concentração de serviços.

## 2. Metodologia Centrada em Banco de Dados

A arquitetura da solução foi projetada para maximizar o uso do banco de dados, delegando toda a carga de processamento e lógica de negócio para o PostgreSQL, seguindo as melhores práticas de ETL (Extract, Transform, Load) e análise de dados.

  - Carga de Dados (Extract): Os dados brutos do IBGE e INEP, em formatos CSV e Shapefile, foram importados para tabelas no PostgreSQL, centralizando toda a informação em um único ambiente gerenciado.

  - Transformação e Integração com SQL Views (Transform): Esta é a etapa central do projeto. Toda a lógica de negócio foi implementada diretamente no banco de dados através de uma série de VIEWs em cascata:
        Normalização de Chaves: Foi criada uma coluna bairro_norm para padronizar os nomes dos bairros, permitindo uma junção confiável entre as diferentes fontes de dados.
        Agregação de Dados: A VIEW cruzamentos.dados_inep_agregados foi criada para resolver o problema da granularidade dos dados do INEP. Usando SUM() e GROUP BY, ela consolida os dados por escola em totais por bairro (matrículas, número de escolas públicas/privadas), um pré-processamento essencial.
        Cálculo de Indicadores: A VIEW cruzamentos.cobertura_escolar_por_faixa_etaria realiza a junção dos dados do IBGE e INEP e calcula todos os indicadores primários (taxas de cobertura), deixando os dados prontos para a análise.
        Classificação e Lógica de Negócio: A VIEW final, cruzamentos.analise_tipologia_bairros, contém toda a lógica de classificação, utilizando CASE WHEN para categorizar cada bairro em uma tipologia (Polo, Deserto, etc.). Isso demonstra a capacidade do SGBD de encapsular regras de negócio complexas.

  - Análise e Visualização (Load/Analysis): O script em Python atua como um cliente final do banco de dados. Ele não realiza nenhuma transformação ou cálculo analítico; sua única função é executar uma SELECT * na VIEW final e usar os dados já processados e classificados para gerar as visualizações (mapas e gráficos).

## 3. Principais Ferramentas Utilizadas

  - Banco de Dados: PostgreSQL
  - Cliente de Análise e Visualização: Python (com Pandas, GeoPandas, SQLAlchemy, Matplotlib, Seaborn)
  - Visualização de Mapas: QGIS

## 4. Estrutura do Repositório

  - /sql_scripts: Contém os scripts SQL para criar as tabelas e as VIEWs de análise no PostgreSQL.
  - /python_analysis: Contém os scripts Python para gerar os gráficos e o shapefile final com a tipologia dos bairros.
  - /shapefile_output: Pasta onde o shapefile final com os resultados da análise é salvo.
