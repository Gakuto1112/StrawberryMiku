言語: 　[English](./README.md)　|　**日本語**

# StrawberryMiku
<!-- DESCRIPTION_START -->
MinecraftのスキンMod「[Figura](https://modrinth.com/mod/figura)」向けスキン「StrawberryMiku（苺ミク）」です。

ターゲットFiguraバージョン：[0.1.5](https://modrinth.com/mod/figura/version/0.1.5b+1.21.4)
<!-- DESCRIPTION_END -->

![メイン画像](./README_images/main.jpg)

## 特徴
- トライデントが専用のモデルに置き換えられます。

  ![トライデントの専用モデル](./README_images/trident.jpg)

- プレイヤーの移動に合わせて髪がたなびきます。

  ![髪がたなびく](./README_images/hair.gif)

### アバターのバージョン表示
v1.1.0より、アクションホイールを開けている際に、画面左上に現在使用中のアバターのバージョンとアップデートの有無が表示されます。

![アバターバージョン表示](./README_images/version_information.jpg)

アップデートの確認は、1日1回自動で行われますが、アクションホイール（デフォルトはBキー）より手動で行うこともできます。

新しいアバターのバージョンが利用可能な場合は、通知が送信されます。アクションホイールより最新バージョンのダウンロードリンクが取得できますので、お使いのブラウザからアクセスしてください。

> [!IMPORTANT]
> アップデートの確認を行うには、Figuraの設定から、「Allow Networking」を有効にし、`api.github.com`を通信許可リストに入れる必要があります！

> [!CAUTION]
> FiguraのNetworking機能を有効にする際に、ネットワークフィルターを「Whitelist」以外で運用するのは危険です。このアバターでは安全なリンクを利用しますが、他のプレイヤーのアバターが利用するリンクが安全である保障はありません。また、この機能を使用して発生したいかなる損害の責任も負いかねます。

> [!WARNING]
> アップデートの確認を短時間で繰り返し行うと、一時的にGitHub側から制限が課せられ、しばらくの間アップデートの確認を行えなくなります。

## 使用方法
Figuraは[Forge](https://files.minecraftforge.net/net/minecraftforge/forge/)、[Fabric](https://fabricmc.net/)、[NeoForge](https://neoforged.net/)に対応しています。

1. 使用したいModローダーをインストールし、Modを使用できる状態にします。
2. [Figura](https://modrinth.com/mod/figura)を追加します。Modの依存関係にご注意ください。
3. [リリースページ](https://github.com/Gakuto1112/StrawberryMiku/releases)に移動します。
   - [レポジトリのトップページ](https://github.com/Gakuto1112/StrawberryMiku)の右側からも移動できます。
4. リリースノート内の「Assets」の項目にアバターのzipファイルが添付されているので、お好みのアバターをダウンロードします。
5. 圧縮ファイルを展開し、中にあるアバターデータを取り出します。
6. `<マインクラフトのゲームフォルダ>/figura/avatars/`にアバターのデータを配置します。
   - Figuraを導入した状態で一度ゲームを起動すると自動的に作成されます。存在しない場合は手動での作成も可能です。
7. ゲームメニューからFiguraメニュー（Δマーク）を開きます。
8. 画面左のアバターリストからアバターを選択します。
9. 必要に応じて権限設定をして下さい。
10. アバターをサーバーにアップロードすると、他のFiguraプレイヤーもあなたのアバターを見ることができます。
    - **海賊版（割れ、非正規版、無料版）のマインクラフトでは、アバターをアップロードすることはできません。**
    これはFiguraの仕様であり、これに関しては対応できません。

## 注意事項
- このアバターを使用して発生した、いかなる損害の責任も負いかねます。
- このアバターは、デフォルトのリソースパックでの動作を想定しています。また、他MODの使用は想定していません。想定動作環境外ではテクスチャの不整合、防具が表示されない/非表示にならない、といった不具合が想定されます。この場合の不具合は対応しない場合がありますのでご了承下さい。
- 不具合がありましたら、[Issues](https://github.com/Gakuto1112/StrawberryMiku/issues)までご連絡下さい。
- アバター関係で私に連絡したい方は[Discussions](https://github.com/Gakuto1112/StrawberryMiku/discussions)または、[Discord](https://discord.com/)でご連絡下さい。私のDiscordのアカウント名は「vinny_san」で表示名は「ばにーさん」です。[FiguraのDiscordサーバー](https://discord.gg/figuramc)での表示名は「BunnySan/ばにーさん」です。

## 参考
- [苺ミク【MMDモデル配布】 _ 不沈空母 さんのイラスト - ニコニコ静画 (イラスト)](https://seiga.nicovideo.jp/seiga/im11019402)
- [苺やフリルに彩られた豪華な衣装に注目！15周年記念にちなんだ”苺”モチーフのキュートな初音ミクがスケールフィギュア化！ _ 電撃ホビーウェブ](https://hobby.dengeki.com/news/1658674/)
