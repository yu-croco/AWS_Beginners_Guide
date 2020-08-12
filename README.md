# AWS Begginer's Guide

## 概要
AWSにこれから入門される方のためのハンズオン用レポジトリ。

クラウドインフラを扱う上での重要な考え方を学ぶところから始まり、実際にインフラを構築するところまでをまとめている。

AWSアカウントを持っている前提で進めていく。

## セットアップ
このレポジトリでは[Terraform](https://www.terraform.io/)を使っていくので、以下の手順に沿ってTerraformが使えるように準備する。
なお、AWSのアカウントは事前に用意していることを前提にしていますので、まだの方は調べてみてください。

- AWS CLIの準備

```
$ pip3 install awscli --upgrade
$ aws --version
```

- 環境変数を設定する

```
$ export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
$ export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
$ export AWS_DEFAULT_REGION=ap-northeast-1
```

- TerraformのAWSアカウントを指定して、ローカルからAWS CLIを使えることを確認する

```
$ aws sts get-caller-identity --query Account --output text
# --> 3550990xxxxxxxx (AWSアカウントIDが出力されればOK)
```

- Terraformをインストールする
  - Terraformはバージョン管理がダルイのでtfenvを使う

```
$ brew install tfenv
$ tfenv
tfenv 2.0.0
Usage: tfenv <command> [<options>]

Commands:
   install       Install a specific version of Terraform
   use           Switch a version to use
   uninstall     Uninstall a specific version of Terraform
   list          List all installed versions
   list-remote   List all installable versions
```

tfenvがインストールできたらひとまず完了
terraformを実際に使っていくのは[2_network](./README.md)からになる予定

## 構成
- 各ディレクトリー名の先頭に数字を振っており、数字が小さい方から進めていく

```
.
├── 0_fundamental_concept    <- クラウドインフラを使う上で知っておいて欲しい前提
├── 1_infrastructure_as_code <- インフラの（雑な）歴史とIaC
├── 2_network                <- VPC/subnet/EC2などの紹介とハンズオン
├── 3_container              <- Dockerコンテナの紹介とハンズオン
├── 4_references             <- （クラウド）インフラ周りの勉強をする上で役立つ情報源のサマリー
└── README.md
```

## 免責事項
当リポジトリに記載された内容は情報の提供のみを目的としています。
したがって、当リポジトリを用いた開発、運用は必ずご自身の責任と判断によって行ってください。
これらの情報による開発、運用の結果について、作者はいかなる責任も負いません。
