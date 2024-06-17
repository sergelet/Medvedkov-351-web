from flask_login import current_user

class CheckUser:
    def __init__(self, record):
        self.record = record
    def create(self):
        return current_user.is_admin()
    def show(self):
        return True
    def edit(self):
        if current_user.id == self.record.id:
            return True
        return current_user.is_admin()
    def delete(self):
        return current_user.is_admin()
    def show_user(self):
        return current_user.is_admin()
    def show_route(self):
        return current_user.is_admin()