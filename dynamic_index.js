<html>
    <body>
        <h1 id="bucket"></h1>
        <table id="listing" style="border-spacing: 2em 0em;">
            <tr><th>Object</th><th>Size (bytes)</th><th>Date</th></tr>
        </table>

        <script>

         let bucket = (window.location.href.match(/^.*\//))[0];

         function listingXMLDocToTableStr(xmldoc) {
             let eValue = (e, tag) =>
                 e.getElementsByTagName(tag)[0].firstChild.nodeValue;
             return Array
                 .from(xmldoc.getElementsByTagName('Contents'))
                 .map(c =>
                     ({'name' : eValue(c, 'Key'),
                       'size' : eValue(c, 'Size'),
                       'date' : eValue(c, 'LastModified')}))
                 .filter(c =>
                     ! c.name.match(/.*_ometa$/))
                 .map(c =>
                     `<tr>
                        <td><a href="${c.name}">${c.name}</a></td>
                        <td>${c.size}</td>
                        <td>${c.date}</td>
                     </tr>`)
                 .join('\n');
         };

         document.getElementById('bucket').innerHTML = bucket;

         fetch(bucket)
             .then(response =>
                 response.text())
             .then(str =>
                 (new window.DOMParser()).parseFromString(str, "text/xml"))
             .then(xmldoc =>
                 document.getElementById('listing').innerHTML +=
                     listingXMLDocToTableStr(xmldoc));
        </script>

    </body>
</html>



