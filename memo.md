
Head First Rails を見ながらやってみる。

# もろもろインストール

* RubyInstaller で ruby 1.9.3 をインストール (http://rubyinstaller.org/downloads/)
* DevKit もインストール (http://rubyinstaller.org/downloads/)
* gem install rails
* gem install sqlite3
* gem udpate --system (rails new で失敗するので)

## DevKit のインストール手順

DevKit-tdm-32-4.5.2-20111229-1559-sfx.exe を実行して、 C:\RubyDevKit など適当なディレクトリに展開する。

```
$ cd C:\RubyDevKit
$ ruby dk.rb init
```

生成された config.yml に ruby のインストールパスがあればOK

```
$ ruby dk.rb install
```

## １章

```
$ rails new tickets   # 基本ファイル群の生成
$ cd tickets
$ rails server        # 開発用Webサーバーの起動
```

ブラウザで http://localhost:3000 につないでみると Welcome ページが見える。

チケットを扱うための土台(scaffold)を作る。

```
rails generate scaffold ticket name:string seat_id_seq:string address:text price_paid:decimal email_address:string
```

最初 rails new *ticket* で rails generate scaffold *ticket* と両方 ticket としていたら怒られたが、 rails new tickets でやりなおしたらできた。

db/migrate/20120721110636_create_tickets.rb ができた。

次は、データベースにテーブルを作る。

```
rake db:migrate
```

http://localhost:3000/tickets を見るとチケットリストが見えるが、まだ何も登録されていないので、 New Ticket で作ってみたりしてみるといい。

電話番号を追加。

```
$ rails generate migration AddPhoneToTickets phone:string
      invoke  active_record
      create    db/migrate/20120721114131_add_phone_to_tickets.rb
```

db/migrate/20120721114131_add_phone_to_tickets.rb ができた。

```
$ rake db:migrate
```

ブラウザから新しいレコードを追加しようとしたらエラーが出た。

```
ActiveModel::MassAssignmentSecurity::Error in TicketsController#create

Can't mass-assign protected attributes: phone
```

モデルのコード(app/models/ticket.rb)に :phone が追加されていないからのようだ。

```ruby
class Ticket < ActiveRecord::Base
  attr_accessible :address, :email_address, :name, :price_paid, :seat_id_seq :phone
end
```

新しいテーブルを作る。

```
$ rails g scaffold event artist description:text price_low:decimal price_high:decimal event_date:date
$ rake db:migrate
```
## ２章

MeBayのアプリケーションを作る。

```
rails new mebay
```

モデルを作る。

```
$ rails g model ad name description:text price:decimal seller_id:integer email img_url
$ rake db:migrate
```

コントローラを作る。

```
$ rails g controller ads
```

ビュー(app/views/ads/show.html.erb)を作る。

ルート(config/routes.rb)を設定する。

```ruby
Mebay::Application.routes.draw do
  match 'ads/:id' => 'ads#show'
end
```

コントローラー(app/controllers/ads_controller.rb)のコードを修正。

```ruby
class AdsController < ApplicationController
  def show
    @ad = Ad.find(params[:id])
  end
end
```

ビュー(app/views/ads/show.html.erb)に <%= @ad.name %> などを追加。

# 参考
* http://railsapps.github.com/rails-heroku-tutorial.html
* http://nextjewel.blogspot.jp/search/label/Head%20First%20Rails%20Rails3%E5%AF%BE%E5%BF%9C%E3%83%A1%E3%83%A2
* http://blog.be-open.net/ruby_on_rails/try-head-first-rails/
* http://d.hatena.ne.jp/iishun/20120423/1335200728 のコメント
