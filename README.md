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
$ brew install awscli
$ aws --version
# 以下のように出ればOK
aws-cli/2.1.30 Python/3.9.2 Darwin/20.3.0 source/x86_64 prompt/off
```

- AWS CLI Configを設定する
  - 参考
    - [設定の基本 - AWS Command Line Interface](https://docs.aws.amazon.com/ja_jp/cli/latest/userguide/cli-configure-quickstart.html)
    - [AWS CLI のコンフィグファイルと環境変数とコマンドラインオプションで指定できる内容をまとめて確認してみた](https://dev.classmethod.jp/articles/aws-cli-configuration-file-env-option/)

```
$ aws configure
AWS Access Key ID [None]: xxxxxxxx
AWS Secret Access Key [None]: xxxxxxxx
Default region name [None]: ap-northeast-1
Default output format [None]: json
```

- TerraformのAWSアカウントを指定して、ローカルからAWS CLIを使えることを確認する

```
$ aws sts get-caller-identity --profile ${profile_name}
{
    "UserId": "xxxxxxxxxxxxxxxx",
    "Account": "01234567890123",
    "Arn": "arn:aws:sts::01234567890123:xxxxxxxxxxxxx"
}
```

- Session Manager plugin for the AWS CLIをインストールする
  - ハンズオンにおいてEC2に対してSSHする際に利用する
  - 手順: [(Optional) Install the Session Manager plugin for the AWS CLI](https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-working-with-install-plugin.html)

- Terraformをインストールする
  - Terraformはバージョン管理がダルイのでtfenvを使う

```
$ brew install tfenv
$ tfenv
tfenv 2.2.3
Usage: tfenv <command> [<options>]

Commands:
   install       Install a specific version of Terraform
   use           Switch a version to use
   uninstall     Uninstall a specific version of Terraform
   list          List all installed versions
   list-remote   List all installable versions
   version-name  Print current version
   init          Update environment to use tfenv correctly.
   pin           Write the current active version to ./.terraform-version
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
