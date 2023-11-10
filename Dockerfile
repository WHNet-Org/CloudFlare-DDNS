FROM harbor.whnet.ca/microsoft/powershell:alpine-3.14

RUN mkdir /code
COPY . /code/

CMD ["/usr/bin/pwsh","/code/Go.ps1"]
