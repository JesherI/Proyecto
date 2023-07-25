class Config:
    SECRET_KEY = '1111111'

class DevelopmenConfig():
    DEBUG = True
    MYSQL_HOST = 'localhost'
    MYSQL_USER = 'root'
    MYSQL_PASSWORD = ''
    MYSQL_DB = 'spvbl'

config = {
    'development': DevelopmenConfig
}