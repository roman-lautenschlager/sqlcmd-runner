# sqlcmd-runner

## Wrapper for Microsoft SQL Server SQLCmd

- connect with parameters from environment variables
- run all *.sql files from provided path in order

### Prerequisites
- sqlcmd in $PATH
- BASH or PowerShell

### RTFM

[New sqlcmd clid for Microsoft SQL Server](https://github.com/microsoft/go-sqlcmd)

[SQL Server technical documentation](https://learn.microsoft.com/en-us/sql/sql-server/?view=sql-server-ver17)

[Transact-SQL reference](https://learn.microsoft.com/en-us/sql/t-sql/language-reference?view=sql-server-ver17)


### .env
```bash
# store connection details and other sqlcmd parameters in local .env file and source it before runs

# Target SQL Server instance name or IP address (e.g., localhost or my-server.database.windows.net). Equivalent to -S
export SQLCMDSERVER=

# Login ID or username for SQL Server authentication. Equivalent to -U
export SQLCMDUSER=

# Password for the login user. Equivalent to -P
export SQLCMDPASSWORD=

# Initial database catalog to connect to immediately upon authorization. Equivalent to -d
export SQLCMDDATABASE=

# Workstation name reported back to SQL Server for auditing purposes. Equivalent to -H
export SQLCMDWORKSTATION=

# Number of seconds before a connection attempt times out. Equivalent to -l
export SQLCMDLOGINTIMEOUT=

```

### .sql
```sql
-- use environment variables in sql
select $(VariableName)
```

### .run
```sh
# BASH
BASH_ENV=.env ./sqlcmdrun.sh ./sql
```

```powershell
# POWERSHELL
$env:SQLCMDSERVER=""
$env:SQLCMDUSER=""
$env:SQLCMDPASSWORD=""
$env:SQLCMDDATABASE=""

.\sqlcmdrun.sh .\sql
```
