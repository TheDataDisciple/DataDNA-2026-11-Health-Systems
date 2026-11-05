using System;
using System.Globalization;
using System.IO;
using System.Text;

// Serializes only native Excel result values. It contains no validation rules.
public static class NativeCsvBridge
{
    static string Value(object value)
    {
        if (value == null || value == DBNull.Value) return "";
        if (value is double)
        {
            var number = (double)value;
            if (Double.IsNaN(number) || Double.IsInfinity(number))
                throw new InvalidDataException("Non-finite native numeric result");
            return number.ToString("R", CultureInfo.InvariantCulture);
        }
        if (value is bool) return (bool)value ? "true" : "false";
        return Convert.ToString(value, CultureInfo.InvariantCulture);
    }
    static void Row(StreamWriter writer, object[,] values, int row)
    {
        for (int column = values.GetLowerBound(1); column <= values.GetUpperBound(1); column++)
        {
            if (column > values.GetLowerBound(1)) writer.Write(',');
            writer.Write('"');
            writer.Write(Value(values[row, column]).Replace("\"", "\"\""));
            writer.Write('"');
        }
        writer.WriteLine();
    }
    public static void Write(string path, object[,] headers, object[,] data, int expectedRows)
    {
        if (expectedRows < 0 || expectedRows > 100000)
            throw new InvalidDataException("Export exceeds bounded worksheet contract");
        if ((data == null ? 0 : data.GetLength(0)) != expectedRows)
            throw new InvalidDataException("Native result array row count mismatch");
        using (var writer = new StreamWriter(path, false, new UTF8Encoding(false), 1024 * 1024))
        {
            writer.NewLine = "\n";
            Row(writer, headers, headers.GetLowerBound(0));
            if (data != null)
                for (int row = data.GetLowerBound(0); row <= data.GetUpperBound(0); row++)
                    Row(writer, data, row);
        }
    }
}
