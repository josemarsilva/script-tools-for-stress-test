# script-tools-for-stress-test

## 1. Introdução ##

Este repositório contém os códigos fontes de diversos scripts que podem ajudar em projetos de Stress Test.

## 2. Script Tools ##

### 3.1. MySql Data Generator ###

* **Sumário**:
O **MySql Data Generator** é um stored procedure MySQL que após ser instalado permite que sejam gerados novos registros para uma determinada tabela com base nos registros existentes.

* **Cenários de uso**:
    * Suponha um projeto onde você precise __n-plicar__ , isto é multiplicar por "n" a quantidade de registros da tabela ( `customers` )
    * Você sabe que a __primary-key__ desta tabela é a coluna `id` e ela é automaticamente preenchida por uma sequence
	* Você quer __n-plicar__ a quantidade de registros existentes, criando mais **5000** novos registros, copiando os registros existentes, apenas transformando os valores dos registros cuja chave não pode duplicar
	* [Script demonstração de uso](./src/mysql-datagenerator-tool/mysql-datagenerator-tool-execute-example.sql): 

* **Pré-requisitos**:
    * MySql database

* Fonte/Scripts:

    * [mysql-datagenerator-tool-create-procedures](./src/mysql-datagenerator-tool/mysql-datagenerator-tool-create-procedures.sql): 


```sql

```


## Referências ##

* n/a
