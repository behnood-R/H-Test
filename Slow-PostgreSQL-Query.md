Slow PostgreSQL Query

We noticed slow performance on a specific database query. The output from EXPLAIN ANALYZE on the query is below. This query pulls data to render a chart of pricing information over time. What do you notice in the query plan, and how might you optimize it?

```
Hash Left Join (cost=126.50..148.74 rows=1008 width=44) (actual time=1.060..41.489 rows=858 loops=1)
Hash Cond: (c0.id = a3.company_id)

Join Filter: ((generate_series(('2022-01-01'::date)::timestamp with time zone, (date(timezone('America/New_York'::text, now())))::timestamp with time zone, '1 day'::interval)) = a3.price_day)

Rows Removed by Join Filter: 361371

-> Nested Loop (cost=90.87..110.47 rows=1000 width=56) (actual time=0.682..1.079 rows=858 loops=1)

-> Index Only Scan using companies_pkey on companies c0 (cost=0.28..4.30 rows=1 width=16) (actual time=0.012..0.013 rows=1 loops=1)

Index Cond: (id = '8d4c1967-391a-43dc-a231-d8e013f98ab5'::uuid)

Heap Fetches: 0

-> Merge Left Join (cost=90.59..96.17 rows=1000 width=40) (actual time=0.669..0.988 rows=858 loops=1)

Merge Cond: ((generate_series(('2022-01-01'::date)::timestamp with time zone, (date(timezone('America/New_York'::text, now())))::timestamp with time zone, '1 day'::interval)) = sp0.transaction_at)

-> Sort (cost=64.86..67.36 rows=1000 width=8) (actual time=0.573..0.635 rows=858 loops=1)

Sort Key: (generate_series(('2022-01-01'::date)::timestamp with time zone, (date(timezone('America/New_York'::text, now())))::timestamp with time zone, '1 day'::interval))

Sort Method: quicksort Memory: 65kB

-> ProjectSet (cost=0.00..5.03 rows=1000 width=8) (actual time=0.278..0.447 rows=858 loops=1)

-> Result (cost=0.00..0.01 rows=1 width=0) (actual time=0.001..0.001 rows=1 loops=1)

-> GroupAggregate (cost=25.73..25.87 rows=7 width=36) (actual time=0.092..0.144 rows=55 loops=1)

Group Key: sp0.transaction_at

-> Sort (cost=25.73..25.75 rows=7 width=8) (actual time=0.087..0.094 rows=59 loops=1)

Sort Key: sp0.transaction_at

Sort Method: quicksort Memory: 27kB

-> Bitmap Heap Scan on priced_transactions sp0 (cost=4.33..25.63 rows=7 width=8) (actual time=0.022..0.074 rows=59 loops=1)

Recheck Cond: (company_id = c0.id)

Heap Blocks: exact=45

-> Bitmap Index Scan on e1bbce45cf6637c020f7f1e176304403 (cost=0.00..4.33 rows=7 width=0) (actual time=0.010..0.010 rows=62 loops=1)

Index Cond: (company_id = c0.id)

-> Hash (cost=26.38..26.38 rows=740 width=24) (actual time=0.298..0.298 rows=739 loops=1)

Buckets: 1024 Batches: 1 Memory Usage: 49kB

-> Index Scan using "23b2c2d0cf8178b0df68aae6052dc300" on aggregate_price_graph a3 (cost=0.43..26.38 rows=740 width=24) (actual time=0.037..0.200 rows=739 loops=1)

Index Cond: (company_id = '8d4c1967-391a-43dc-a231-d8e013f98ab5'::uuid)

Planning Time: 0.813 ms

Execution Time: 41.610 ms
```


At first, in these logs, the query is removing a massive amount of rows `Rows Removed by Join Filter: 361371`, which is the most important issue I noticed.

And the most expensive one is `Join Filter: (generate_series(...) = a3.price_day)`, which tells you that most of the time it is being burned in the join/filter logic, not in the base table scans.


