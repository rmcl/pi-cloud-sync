# piCloudSync

A RaspberryPi based file server that syncs files to a s3 bucket.

## How it Works

* Install onto a raspberry pi on your network.
* Connect to the pi as a guest via SAMBA (should work Mac/Windows/Linux)
* Drag files into the "upload" directory. Files will be automatically uploaded to a s3 bucket of your choice. 
* Successfully uploaded files are moved to the "complete" folder and deleted after 10 days. Files that failed to upload are moved to the "failed" directory and there they will remain. Drag back to the upload directory to retry.
