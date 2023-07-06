1. アプリケーションの新規作成手順
# ターミナルにて
# ホームディレクトリへ移動
% cd
# projectsディレクトリに移動
% cd ~/projects
# Railsのバージョン7.0.0を用いて、FirstAppを作成
% rails _7.0.0_ new first_app -d mysql
# 「first_app」ディレクトリに移動
% cd first_app
# 現在のディレクトリのパスを表示
% pwd
# データベースの作成
% rails db:create
# Sequel Proなどでテータを入力
# ターミナルからテータ入力
# コンソールを起動
% rails c
irb(main):001:0> post = Post.new
irb(main):002:0> post.content = "こんにちは！"
irb(main):003:0> post.save
irb(main):007:0> exit


2. 一覧機能（indexアクション）を実装する

# ルーティングを設定
# config/routes.rb を編集
Rails.application.routes.draw do
  get 'posts', to: 'posts#index'
 end

 # ターミナルにて
# first_appディレクトリにいることを確認
% pwd
# postsコントローラーを作成
% rails g controller posts
# app/controllers/posts_controller.に追記
  def index  # indexアクションを定義した
    @posts = Post.all  # すべてのレコードを@postsに代入
  end

# app/views/postsディレクトリを選択してindex.html.erbを作成
<h1>トップページ</h1>
<% @posts.each do |post| %>
  <div class="post">
    <div class="post-date">
      投稿日時：<%= post.created_at %>
    </div>
    <div class="post-content">
      <%= post.content %>
    </div>
  </div>
<% end %><>

# マイグレーションファイルを編集
class CreatePosts < ActiveRecord::Migration[6.0]
  def change
    create_table :posts do |t|
      t.text :content
      t.timestamps
    end
  end
end
# マイグレーションを実行
# first_appのディレクトリにいることを確認
% pwd
# マイグレーションを実行
% rails db:migrate

3. 投稿画面（newアクション）を作成する手順
# ルーティングを設定
# config/routes.rb
Rails.application.routes.draw do
  get 'posts', to: 'posts#index'
  get 'posts/new', to: 'posts#new'
end
# アクションを定義
# app/controllers/posts_controller.rbに追記
def new
end

# ビューファイルを編集
# app/views/posts/new.html.erb を作成
<h1>新規投稿ページ</h1>
<%= link_to '新規投稿', '/posts/new' %>    <>
<%= form_with url: "/posts", method: :post, local: true do |form| %>
  <%= form.text_field :content %>
  <%= form.submit '投稿する' %>
<% end %>
# app/assets/stylesheets/posts.cssを作成
.post{
  border: 1px solid;
  width: 40%;
  margin-top: 30px;
}
.post-date{
  color: gray;
}

4. 保存機能（createアクション）を実装する手順
# ルーティングを設定
# config/routes.rb
Rails.application.routes.draw do
  get 'posts', to: 'posts#index'
  get 'posts/new', to: 'posts#new'
  post 'posts', to: 'posts#create'
end

# アクションを定義
# app/controllers/posts_controller.rbに追記
def create
  Post.create(content: params[:content])
  redirect_to "/posts" # リダイレクト、一覧に戻る
end