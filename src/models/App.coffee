# TODO: Refactor this model to use an internal Game Model instead
# of containing the game logic directly.
class window.App extends Backbone.Model
  initialize: ->
    @set 'deck', deck = new Deck()

    @set 'playerHand', deck.dealPlayer()
    @set 'dealerHand', deck.dealDealer()

    @get('dealerHand').on('handsUp', @compare, @)
    @on('handOver', @newGame, @)

  compare: ()->
    console.log('im comparing')
    if (@get('playerHand').isBust() and @get('dealerHand').isBust())
      alert('busty town')
    else if (@get('playerHand').isBust() and not @get('dealerHand').isBust())
      alert('dealer wins')
    else if (not @get('playerHand').isBust() and @get('dealerHand').isBust())
      alert('player wins')
    else
      playerScore = @getScore('player')
      dealerScore = @getScore('dealer')
      if playerScore <= dealerScore
        alert('dealer wins')
      else
        alert('player wins')

    # trigger 'game over, please redeal'
    @trigger('handOver')

  getScore: (player)->
    playerScores = @get(player+'Hand').scores()
    if playerScores[1] > 21 then playerScores[0] else playerScores[1]

  newGame: () ->
    @get('playerHand').reset(@get('deck').subsequentPlayerDeal())
    @get('dealerHand').reset(@get('deck').subsequentDealerDeal())
    @get('playerHand').newHand()


  dealHands: () ->

