#! /bin/bash

# GoogleDriveでは、ファイルは固有のIDベースで管理されるため、複数回実行すると
# ファイルが次々に蓄積されます。適宜手作業で削除してください。

# 送信テスト 対象フォルダは pictures-0
export MUKOYAMA_ID=0
export MUKOYAMA_DELETE_IMG=false
python3 scripts/post2googledrive.py test/poo.png

# 削除のテスト
cp test/poo.png test/poo2.png
export MUKOYAMA_DELETE_IMG=true
python3 scripts/post2googledrive.py test/poo2.png
