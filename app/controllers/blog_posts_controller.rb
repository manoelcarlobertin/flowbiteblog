class BlogPostsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  before_action :authenticate_admin!, except: %i[ index show ]
  before_action :set_blog_post, only: %i[ show edit update destroy ]

  def index
    @blog_posts = BlogPost.all
  end

  def show;end

  def new
    @blog_post = BlogPost.new
  end

  def edit;end

  def create
    @blog_post = BlogPost.new(blog_post_params)

    if @blog_post.save
      redirect_to @blog_post, notice: "Conteúdo criado com sucesso."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @blog_post.update(blog_post_params)
      redirect_to @blog_post, notice: "Conteúdo atualizado com sucesso."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @blog_post.destroy!

      redirect_to blog_posts_path, status: :see_other, notice: "Conteúdo apagado com sucesso."
  end

  private
  def record_not_found
    flash[:alert] = "Conteúdo não encontrado."
    redirect_to root_path
  end

  def set_blog_post
    # esse modo logo abaixo também funciona digitando,localhost:3000/b/1
    @blog_post = BlogPost.friendly.find(params.expect(:id))
  end

  def blog_post_params
    params.expect(blog_post: [ :title, :body, :meta_description, :meta_title, :meta_image, :banner_image, :tags ])
  end
end
