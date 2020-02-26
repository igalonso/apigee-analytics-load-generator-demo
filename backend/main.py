
import random

from services.catalog import *
from services.user import *
from services.loyalty import *
from services.checkout import *
from services.recommendation import *
from flask import Flask



# If `entrypoint` is not defined in app.yaml, App Engine will look for an app
# called `app` in `main.py`.
app = Flask(__name__)

#Catalog service
@app.route('/catalog',methods=['GET', 'POST'])
def catalog(): 
    return {}

@app.route('/catalog/<int:id>')
def product(id):
    # show the post with the given id, the id is an integer
    return getCatalog(id)

#Loyalty service
@app.route('/loyalty',methods=['GET', 'POST'])
def loyalty(): 
    return {}

@app.route('/loyalty/<int:id>')
def loyaltyMember(id):
    """Return a friendly HTTP greeting."""
    return getTotalLoyaltyPoints(id)

#Customer service
@app.route('/user',methods=['GET', 'POST'])
def customers():
    """Return a friendly HTTP greeting."""
    return {}
@app.route('/user/<int:id>')
def customer(id):
    """Return a friendly HTTP greeting."""
    return getUsers(id)

#Checkout cart service 
@app.route('/checkout',methods=['GET', 'POST'])
def checkout():
    """Return a friendly HTTP greeting."""
    return {}
@app.route('/checkout/<int:id>')
def checkoutCart(id):
    """Return a friendly HTTP greeting."""
    return getCheckout(id)

#Recommendation based on item service
@app.route('/recommendation',methods=['GET', 'POST'])
def recommendation():
    """Return a friendly HTTP greeting."""
    return {}
@app.route('/recommendation/<int:id>')
def recommendationBasedOnItem(id):
    """Return a friendly HTTP greeting."""
    return getRecommendation(id)


if __name__ == '__main__':
    # This is used when running locally only. When deploying to Google App
    # Engine, a webserver process such as Gunicorn will serve the app. This
    # can be configured by adding an `entrypoint` to app.yaml.
    app.run(host='127.0.0.1', port=8080, debug=True)
# [END gae_python37_app]
