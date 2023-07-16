import os
from werkzeug.utils import secure_filename
from flask import current_app

# f: file Object from Form
# location: profiles, products, ...
# idx: identifier for update images (remove / create)
def save_image(f, location, idx=''):
    filename = secure_filename(f.filename)
    location = f'static/{ location }'
    if idx:
        filename = f'{ idx }-' + filename
    f.save(os.path.join(current_app.root_path, location, filename))
    return filename