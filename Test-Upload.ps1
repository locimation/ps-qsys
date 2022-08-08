$HttpClient = [System.Net.Http.HttpClient]::new();
$HttpClient.DefaultRequestHeaders.Add("Accept", "application/json");

$DesignCode = "2UsWW1kcxPli"

$Content = [System.Net.Http.MultipartFormDataContent]::new();
$FileStream = [System.IO.File]::OpenRead("D:\Dropbox\Locimation\Projects\PS-QSYS\2UsWW1kcxPli.tar.gz");
$FileContent = [System.Net.Http.StreamContent]::new($FileStream);
$FileContent.Headers.ContentType = "application/gzip";
$FileContent.Headers.ContentDisposition = 'form-data; name="designtar"; filename="2UsWW1kcxPli.tar.gz"'

$TextContent = [System.Net.Http.StringContent]::new("untitled-design", [System.Text.Encoding]::ASCII);
$TextContent.Headers.ContentType = "text/plain";
$TextContent.Headers.ContentDisposition = 'form-data; name="prettyname"';

$Content.Add($TextContent, "prettyname");
$Content.Add($FileContent, "designtar", $DesignCode + ".tar.gz");

$result = $HttpClient.PutAsync("http://10.10.10.4/api-qsd/v0/designs/" + $DesignCode, $Content).Result;
$result.EnsureSuccessStatusCode();