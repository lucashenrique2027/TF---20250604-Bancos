# Projeto de Escalabilidade e Otimização em NoSQL

## Parte 1: Modelagem de Dados
**Banco escolhido:** MongoDB (orientado a documentos).  
**Justificativa:** Flexibilidade na modelagem, fácil evolução do schema e ideal para dados semi-estruturados como entregas.

**Modelo da coleção `entregas`:**
- id_entrega (string)
- id_cliente (string)
- origem (subdocumento: endereço, cidade, estado)
- destino (subdocumento: endereço, cidade, estado)
- status (string)
- data_coleta (data)
- data_entrega (data ou null)

---

## Parte 2: Escalabilidade

**Tipo:** Horizontal  
**Motivo:** Suporte à distribuição de carga com alta escalabilidade em sistemas distribuídos.

**Sharding:**
- Tipo: Geográfico
- Chave: origem.estado
- Justificativa: Alta distribuição por região facilita balanceamento de carga e latência.

---

## Parte 3: Otimização de Consultas

**Consulta:** Buscar entregas "em trânsito" de um cliente
```js
db.entregas.find({ id_cliente: "CLI123", status: "em trânsito" })
```

**Otimizações:**
- Índice composto:
```js
db.entregas.createIndex({ id_cliente: 1, status: 1 })
```
- Projeção:
```js
db.entregas.find({ id_cliente: "CLI123", status: "em trânsito" }, { id_entrega: 1, origem: 1, destino: 1 })
```
- Uso de explain:
```js
db.entregas.find({ id_cliente: "CLI123", status: "em trânsito" }).explain("executionStats")
```

---

## Parte 4: Monitoramento e Métricas

**Métricas críticas:**
1. Latência de leitura/escrita
2. Espaço em disco
3. Throughput (ops/s)

**Rebalanceamento de partições:**  
Se determinada região (`origem.estado`) estiver com shard desbalanceado (por ex. SP com 80% das entregas), usamos o `sh.moveChunk()` do MongoDB para redistribuir os dados entre shards.