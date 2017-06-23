# Motion for Mukoyama
動体検出プログラムMotionを使用して画像を撮影し、Mukoyamaプロジェクトのサーバへ送信します。
Motionが動体を検出した時とMOTION_SNAPSHOT_INTERVALで設定された定時に画像撮影及びサーバ送信が行われます。
raspberry pi と raspberry piカメラモジュールを使用します。

## motionのインストール
```
sudo apt-get install -y motion
```

## 設定
- /etc/modules に追記
```
bcm2835-v4l2
```

- /boot/config.txt に追記
```
start_x=1
gpu_mem=128
disable_camera_led=1
```

- mukoyama.conf.sampleをコピーして名前をmukoyama.confにする

- mukoyama.confを編集
```
export MUKOYAMA_URL=https://mukoyama.lmlab.net:443
export MUKOYAMA_ID=(mukoyamaプロジェクトで発行されたID)
export MUKOYAMA_TOKEN=(mukoyamaプロジェクトで発行された送信用トークン)
export MUKOYAMA_DELETE_IMG=(mukoyamaに画像送信後、その画像を削除するかどうか。trueの時削除し、それ以外は削除しない。)
export MOTION_HOME=(このファイルの置かれたディレクトリ)
export STD_LOG_FILE=(標準出力の接続先 ログ出力しない場合は/dev/null)
export ERR_LOG_FILE=(標準エラー出力の接続先 ログ出力しない場合は/dev/null)
export MOTION_TARGET_DIR=(画像の保存先ディレクトリ)
export MOTION_THRESHOLD=(動体検出の閾値)
export MOTION_STREAM_LOCALHOST=(on/off 外部ホストにストリーミングするか)
export MOTION_SNAPSHOT_INTERVAL=(定時撮影の間隔秒 0の時は定時撮影しない)
export MOTION_ROTATE=(画像の回転角度：0,90,180,270 デフォルト0)
```

## 起動
```
./bin/start.sh
```

## 書き込み先設定
SDカードの書き込み回数制限が気になる場合はメモリを画像の一時保存領域として使う
- メモリ領域をマウントする
```
sudo mkdir /mnt/motion
sudo mount -t tmpfs -o size=10m tmpfs /mnt/motion
sudo chmod 777 /mnt/motion
```

- mukoyama.confを編集、マウントされたメモリ領域を画像の保存先として設定する。
```
export MOTION_TARGET_DIR=/mnt/motion
export MUKOYAMA_DELETE_IMG=true
```

## raspberry pi の起動時に自動的に起動する
/etc/rc.localに追記
```
cd /home/pi/motion_for_mukoyama && ./bin/start.sh
```
