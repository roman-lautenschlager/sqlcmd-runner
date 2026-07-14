# sqlcmd-runner

## Wrapper for Microsoft SQL Server SQLCmd

- connect with parameters from environment variables
- run all *.sql files from provided path in order

### Prerequisites
- sqlcmd in $PATH
- BASH or PowerShell

### RTFM
[New sqlcmd cli for Microsoft SQL Server](https://github.com/microsoft/go-sqlcmd)

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
export SQLCMDDBNAME=

# Workstation name reported back to SQL Server for auditing purposes. Equivalent to -H
export SQLCMDWORKSTATION=

# Number of seconds before a connection attempt times out. Equivalent to -l
export SQLCMDLOGINTIMEOUT=

```

### .sql
```sql
-- use environment variables in sql
USE $(TARGET_DB);
GO

select '$(ENVIRONMENT_VARIABLE_NAME)'
GO
```

### .run
```sh
# BASH
BASH_ENV=.env ./sqlcmdrun.sh ./path/to/all/files
BASH_ENV=.env ./sqlcmdrun.sh ./path/to/single/file.sql
```

```powershell
# POWERSHELL
$env:SQLCMDSERVER=""
$env:SQLCMDUSER=""
$env:SQLCMDPASSWORD=""
$env:SQLCMDDBNAME=""

.\sqlcmdrun.ps1 .\path\to\all\files
.\sqlcmdrun.ps1 .\path\to\single\file.sql
```
