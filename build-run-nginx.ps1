$NAME = "nginx"
docker build -t $NAME .\srcs\requirements\$NAME\
if ($LASTEXITCODE -eq 0)
{
    Write-Host ""
}
else
{
    exit 1
}

$answer = Read-Host "Launch with -it ? (Y/n)"
if ($answer -eq "y" -or [string]::IsNullOrWhiteSpace($answer))
{
    docker run -it -p 443:443 $NAME
}
else
{
    docker run -p 443:443 $NAME
}