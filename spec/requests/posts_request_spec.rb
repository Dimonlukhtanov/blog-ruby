require 'rails_helper'

new_post_params = {
  title: 'new title',
  summary: 'new summary',
  body: 'new body'
}

RSpec.describe 'Posts', type: :request do
  before do
    user = User.create!(username: 'myName', email: 'user@mail.ru', password: '1234567', id: 1)
    allow_any_instance_of(PostsController).to receive(:current_user).and_return(user)
  end

  describe 'GET /index' do
    it 'renders a successful index' do
      Post.create!(title: 'my Title', summary: 'my summary', body: 'my body', user_id: 1)
      get posts_url
      expect(response).to be_successful
    end
  end

  describe 'GET /show' do
    it 'renders a successful show' do
      post = Post.create!(title: 'my Title', summary: 'my summary', body: 'my body', user_id: 1)
      get post_url(post.id)
      expect(response).to be_successful
    end
  end

  describe 'PATCH /update' do
    it 'check correct change title' do
      post = Post.create!(title: 'my Title', summary: 'my summary', body: 'my body', user_id: 1)
      patch post_url(post.id),
            params: { post: { title: new_post_params[:title], summary: new_post_params[:summary], body: new_post_params[:body] } }
      expect(post.reload[:title]).to eq new_post_params[:title]
    end

    it 'uncorrect change title, check flash messages' do
      post = Post.create!(title: 'my Title', summary: 'my summary', body: 'my body', user_id: 1)
      patch post_url(post.id),
            params: { post: { title: '', summary: new_post_params[:summary], body: new_post_params[:body] } }
      expect(flash[:danger]).to eq 'Статья не обновлена'
    end

    it 'check correct change summary' do
      post = Post.create!(title: 'my Title', summary: 'my summary', body: 'my body', user_id: 1)
      patch post_url(post.id),
            params: { post: { title: new_post_params[:title], summary: new_post_params[:summary], body: new_post_params[:body] } }
      expect(post.reload[:summary]).to eq new_post_params[:summary]
    end

    it 'check correct change body' do
      post = Post.create!(title: 'my Title', summary: 'my summary', body: 'my body', user_id: 1)
      patch post_url(post.id),
            params: { post: { title: new_post_params[:title], summary: new_post_params[:summary], body: new_post_params[:body] } }
      expect(post.reload[:body]).to eq new_post_params[:body]
    end

    it 'redirect post if draft publish' do
      post = Post.create!(title: 'my Title', summary: 'my summary', body: 'my body', user_id: 1)
      patch post_url(post.id),
            params: { post: { title: 'my Title', summary: 'my summary', body: 'my body' }, new_draft: 'Save Post' }
      expect(response).to redirect_to(post_url(post))
    end

    it 'redirect post if no publish' do
      post = Post.create!(title: 'my Title', summary: 'my summary', body: 'my body', user_id: 1, published: false)
      patch post_url(post.id),
            params: { post: { title: 'my Title', summary: 'my summary', body: 'my body' }, new_post: 'Save Post' }
      expect(response).to redirect_to(post_url(post))
    end
  end

  describe 'DELETE /destroy' do
    it 'destroy post a successful' do
      post = Post.create!(title: 'my Title', summary: 'my summary', body: 'my body', user_id: 1)
      delete post_url(post.id)
      expect { post.reload }.to raise_error ActiveRecord::RecordNotFound
    end

    it 'destroy draft post a successful' do
      post = Post.create!(title: 'my Title', summary: 'my summary', body: 'my body', user_id: 1, published: false)
      delete post_url(post.id)
      expect { post.reload }.to raise_error ActiveRecord::RecordNotFound
    end
  end

  describe 'GET /myposts' do
    it 'renders a successful' do
      Post.create!(title: 'my Title', summary: 'my summary', body: 'my body', user_id: 1)
      get myposts_url
      expect(response).to be_successful
    end
  end

  describe 'GET /mydrafts' do
    it 'renders a successful' do
      Post.create!(title: 'my Title', summary: 'my summary', body: 'my body', user_id: 1, published: false)
      get mydrafts_url
      expect(response).to be_successful
    end
  end

  describe 'GET /edit' do
    it 'renders a successful' do
      post = Post.create!(title: 'my Title', summary: 'my summary', body: 'my body', user_id: 1)
      get edit_post_path(post.id)
      expect(response).to be_successful
    end

    it 'success edit draft' do
      post = Post.create!(title: 'my Title', summary: 'my summary', body: 'my body', user_id: 1, published: false)
      get edit_post_path(post.id)
      expect(response).to be_successful
    end
  end

  describe 'POST /up_rate_post' do
    it 'successes up rate post' do
      post = Post.create!(title: 'test Title', summary: 'my summary', body: 'my body', user_id: 1, up_rate: [0])
      get post_up_rate_path(post.id)
      expect(post.reload.up_rate).to eq %w[0 1]
    end
  end

  describe 'POST /down_rate_post' do
    it 'successes up rate post' do
      post = Post.create!(title: 'my Title', summary: 'my summary', body: 'my body', user_id: 1, up_rate: [0])
      get post_down_rate_path(post.id)
      expect(post.reload.down_rate).to eq ['1']
    end
  end

  describe 'GET /create' do
    it 'success create post, check title' do
      post posts_path, params: { post: { title: 'my Title', summary: 'my summary', body: 'my body' }, new_post: 'Save Post' }
      post = Post.all[0]
      expect(post.title).to eq 'my Title'
    end

    it 'success create post, check summary' do
      post posts_path, params: { post: { title: 'my Title', summary: 'my summary', body: 'my body' }, new_post: 'Save Post' }
      post = Post.all[0]
      expect(post.summary).to eq 'my summary'
    end

    it 'success create post, check body' do
      post posts_path, params: { post: { title: 'my Title', summary: 'my summary', body: 'my body' }, new_post: 'Save Post' }
      post = Post.all[0]
      expect(post.body).to eq 'my body'
    end

    it 'success create draft, check title' do
      post posts_path, params: { post: { title: 'my Title', summary: 'my summary', body: 'my body' }, new_draft: 'Save Post' }
      post = Post.all[0]
      expect(post.title).to eq 'my Title'
    end

    it 'success create draft, check summary' do
      post posts_path, params: { post: { title: 'my Title', summary: 'my summary', body: 'my body' }, new_draft: 'Save Post' }
      post = Post.all[0]
      expect(post.summary).to eq 'my summary'
    end

    it 'success create draft, check body' do
      post posts_path, params: { post: { title: 'my Title', summary: 'my summary', body: 'my body' }, new_draft: 'Save Post' }
      post = Post.all[0]
      expect(post.body).to eq 'my body'
    end

    it 'success create draft, check flash messages' do
      post posts_path, params: { post: { title: 'my Title', summary: 'my summary', body: 'my body' }, new_draft: 'Save Post' }
      expect(flash[:success]).to eq 'Добавлено в черновики'
    end

    it 'unsuccess create post, check flash messages' do
      post posts_path, params: { post: { title: '', summary: 'my summary', body: 'my body' }, new_post: 'Save Post' }
      expect(flash[:danger]).to eq 'Статья не создана'
    end
  end
end
