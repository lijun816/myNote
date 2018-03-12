using System;
using System.Data;
using Microsoft.SqlServer.Server;
using System.Data.SqlTypes;
public class FirstSQLCLRProc
{
    [Microsoft.SqlServer.Server.SqlProcedure]
    public static void FirstSQLCLR(out string text)
    {
        SqlContext.Pipe.Send(“Hello world!” + Environment.NewLine);
        text = “My First SQLCLR Assembly!”;
    }
}
