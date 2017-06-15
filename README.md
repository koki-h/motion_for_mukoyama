# Motion for Mukoyama
動体検出プログラムMotionを使用してMukoyamaプロジェクトのサーバへ送信します。
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
export MOTION_HOME=(このファイルの置かれたディレクトリ)
export MOTION_TARGET_DIR=(画像の保存先ディレクトリ)
export MOTION_THRESHOLD=(動体検出の閾値)
export MOTION_STREAM_LOCALHOST=(on/off 外部ホストにストリーミングするか)
```

## 起動
```
./bin/start.sh
```
