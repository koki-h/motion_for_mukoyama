#!/usr/bin/env python
from __future__ import print_function
import httplib2
import os, re, sys, time

from apiclient import discovery
from oauth2client import client
from oauth2client import tools
from oauth2client.file import Storage

try:
    import argparse
    p = argparse.ArgumentParser(parents=[tools.argparser])
    p.add_argument("file",help="Path for the picture to post.")
    flags = p.parse_args()
except ImportError:
    flags = None

# If modifying these scopes, delete your previously saved credentials
# at ~/.credentials/drive-python-quickstart.json
#SCOPES = 'https://www.googleapis.com/auth/drive.metadata.readonly'
SCOPES = 'https://www.googleapis.com/auth/drive'
CLIENT_SECRET_FILE = 'client_secret.json'
APPLICATION_NAME = 'Drive API Python Quickstart'

def get_credentials():
    """Gets valid user credentials from storage.

    If nothing has been stored, or if the stored credentials are invalid,
    the OAuth2 flow is completed to obtain the new credentials.

    Returns:
        Credentials, the obtained credential.
    """
    home_dir = os.path.expanduser('~')
    credential_dir = os.path.join(home_dir, '.credentials')
    if not os.path.exists(credential_dir):
        os.makedirs(credential_dir)
    credential_path = os.path.join(credential_dir,
                                   'drive-python-quickstart.json')

    store = Storage(credential_path)
    credentials = store.get()
    if not credentials or credentials.invalid:
        flow = client.flow_from_clientsecrets(CLIENT_SECRET_FILE, SCOPES)
        flow.user_agent = APPLICATION_NAME
        if flags:
            credentials = tools.run_flow(flow, store, flags)
        else: # Needed only for compatibility with Python 2.6
            credentials = tools.run(flow, store)
        print('Storing credentials to ' + credential_path)
    return credentials

def timestamp(filename):
    """
    Get timestamp from given filename(xxx-yyyymmddhhmmss.jpg).
    Not used for now.
    """
    t = re.split('[-.]',filename)[1]
    t = time.strptime(t,"%Y%m%d%H%M%S")
    # TODO: How to take care of timezone?
    return time.strftime("%Y-%m-%dT%H:%M:%S%z",t)

def main():
    """
    """
    credentials = get_credentials()
    http = credentials.authorize(httplib2.Http())
    service = discovery.build('drive', 'v3', http=http)

    filepath = flags.file # saved file name
    filename = os.path.basename(filepath)
    mid = os.environ['MUKOYAMA_ID']
    delete_img = os.environ['MUKOYAMA_DELETE_IMG']
    foldername = "pictures-%s" % (mid)
    print("local: %s" % (filepath))
    print("remote: %s/%s" % (foldername,filename))

    # Checks if the folder already exists and gets the ID.
    items = service.files().list(q="name = '%s'" % (foldername)).execute().get('files')
    if len(items) == 0:
        body = {'name': foldername,'mimeType': "application/vnd.google-apps.folder"}
        fid = service.files().create(body=body).execute().get('id')
    else:
        fid = items[0]['id']

    # Sends the picture.
    body = { 'name': filename, 'parents':[fid] }
    service.files().create(media_body=filepath, body=body).execute()
    if delete_img == 'true':
        print(filename+" deleted on local.")
        os.remove(filepath)

if __name__ == '__main__':
    main()
