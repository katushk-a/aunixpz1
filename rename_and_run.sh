
#!/bin/bash
#cli args expected -s (name of file) -e (name of extensions)

while getopts s:e: flag
do
        case "${flag}" in
            s) sourcePath=${OPTARG};;
            e) newExtension=${OPTARG};;
        esac
done

function run_server()
{
  pm2 start "gunicorn --bind 0.0.0.0:5000 wsgi:app" --name "$server_process_name"
  pm2 logs -o "logs.txt" -e "error.txt"
}

function stop_server()
{
  pm2 stop $server_process_name 2> /dev/null

  if [[ "$?" = "0" ]]
  then
    pm2 delete $server_process_name
    echo -n "Application dealocated"
  fi
}

server_process_name="FLASK_SERVER"

sourceDirectoryName="$(dirname $sourcePath)"
sourceFileName="$(basename -- "$sourcePath")"
extractedExtension="${sourceFileName##*.}"

if [[ "$extractedExtension" = "$sourceFileName" ]]
then
    echo "You should pass file extension to source path: $sourcePath"
    exit -1
fi

filenameWithoutExtension="${sourceFileName%.*}"

newFileName="$filenameWithoutExtension.$newExtension"
newFilePath="$sourceDirectoryName/$newFileName"

mv "$sourcePath" "$newFilePath"

if [[ "$newFileName" == "server.py" ]]; then
   echo -n "Running new instance of server"
   run_server "$newFilePath"
fi

if [[ "$sourceFileName" = 'server.py' && "$newExtension" != 'py' ]]; then
   stop_server
fi
