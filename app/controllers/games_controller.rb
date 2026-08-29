class GamesController < AdminController
  before_action :set_game, only: %i[ show edit update destroy ]

  def index
    @games = Game.all
  end

  def new
    @game = Game.new(content_module_id: params[:content_module_id])
    @content_module = @game.content_module
  end

  def edit
  end

  def create
    @game = Game.new(game_params)

    respond_to do |format|
      if @game.save
        format.html { redirect_back(fallback_location: games_path, notice: "Game was successfully created.") }
      else
        format.html { render :new, status: :unprocessable_content }
      end
    end
  end

  def update
    respond_to do |format|
      if @game.update(game_params)
        format.html { redirect_to @game, notice: "Game was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @game }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @game.errors, status: :unprocessable_content }
      end
    end
  end

  def destroy
    @game.destroy!

    respond_to do |format|
      format.html { redirect_to games_path, notice: "Game was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    def set_game
      @game = Game.find(params.expect(:id))
    end

    def game_params
      params.expect(game: [ :title, :slug, :content_module_id, :description ])
    end
end
