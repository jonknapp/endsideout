require "test_helper"

class GameAttemptTest < ActiveSupport::TestCase
  test "can start a game attempt" do
    attempt = GameAttempt.create(student: students(:ada), game: games(:one))

    refute attempt.started?

    attempt.start!

    assert attempt.started?
  end

  test "can complete a game attempt" do
    attempt = GameAttempt.create(student: students(:ada), game: games(:one))
    attempt.start!

    refute attempt.finished?

    attempt.finish!("completed")

    assert attempt.finished?
  end

  test "new game attempts have a token" do
    attempt = GameAttempt.create(student: students(:ada), game: games(:one))
    assert attempt.token.present?
  end
end
