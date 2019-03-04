using System;
using System.Data;
using System.IO;
using System.Text;
using System.Web;
using System.Web.Mvc;
using System.Collections;
using System.Collections.Generic;

namespace Reporting.Helpers
{
    public sealed class CsvActionResult : FileResult
    {
        private readonly List<string> _dataTable;

        public CsvActionResult(List<string> dataTable)
            : base("text/csv")
        {
            _dataTable = dataTable;
        }

        protected override void WriteFile(HttpResponseBase response)
        {
            var outputStream = response.OutputStream;
            using (var memoryStream = new MemoryStream())
            {
                WriteDataTable(memoryStream);
                outputStream.Write(memoryStream.GetBuffer(), 0, (int)memoryStream.Length);
            }
        }

        private void WriteDataTable(Stream stream)
        {
            var streamWriter = new StreamWriter(stream, Encoding.Default);

            WriteHeaderLine(streamWriter);
            streamWriter.WriteLine();
            WriteDataLines(streamWriter);

            streamWriter.Flush();
        }

        private void WriteHeaderLine(StreamWriter streamWriter)
        {
            WriteValue(streamWriter, _dataTable[0]);
        }

        private void WriteDataLines(StreamWriter streamWriter)
        {
            foreach (string dataRow in _dataTable)
            {

                WriteValue(streamWriter, dataRow);

                streamWriter.WriteLine();
            }
        }


        private static void WriteValue(StreamWriter writer, String value)
        {
            writer.Write("\"");
            writer.Write(value.Replace("\"", "\"\""));
            writer.Write("\",");
        }
    }
}