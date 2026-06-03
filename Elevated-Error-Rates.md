Elevated Error Rates

We noticed elevated 500 error rates from our platform. When looking at the logs, we saw messages that looked like this:

```
Elixir.DBConnection.ConnectionError: connection not available and request was dropped from queue after 219ms. This means requests are coming in and your connection pool cannot serve them fast enough. You can address this by:
 1. Ensuring your database is available and that you can connect to it

  2. Tracking down slow queries and making sure they are running fast enough

  3. Increasing the pool_size (although this increases resource consumption)

  4. Allowing requests to wait longer by increasing :queue_target and :queue_interval

See DBConnection.start_link/2 for more information
```

These error rates occurred after a recent deployment that introduced a feature querying against a new table. What direction would you take your investigation from here?


Based on what I see, the App's job processing and the DB's connection pool handling are not in balance, meaning the App is faster at accepting new jobs than the DB's connection pooling.
As the issue started after the last deployment, including the changes related to the new table, it was necessary to compare the time when errors started being reported in the logs and events with the deployment time.
The first move would be to determine the issue's scope if:
1. There is a reachability issue with DB or DB pressure.
2. It is affecting limited paths and services or all services (are the critical services affected or not), based on the slow queries, it could be detected.

Compare the results with the latest deployments and changes; if they are relevant to the same changes, roll back the service to recover it and report the issue to the change owner to fix it. ( probably a missing index in the new table, or it is creating an N+1 query pattern,...)
If it is not relevant to the deployments, reduce query counts and batch work to ensure the DB can keep up with the app's processing rate, and start investigating the root cause to fix the issue permanently and prevent it from happening in the future.
The other temporary fix could be increasing the pool size if it is not relevant to the last deployment.
