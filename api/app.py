from datetime import datetime

from flask import Flask, jsonify, request
from flask_cors import CORS
from flask_sqlalchemy import SQLAlchemy

app = Flask(__name__)
CORS(app)

app.config["SQLALCHEMY_DATABASE_URI"] = (
    "mysql+pymysql://root:@localhost/flutter_flask_practice"
)
app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False

db = SQLAlchemy(app)


class Note(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    title = db.Column(db.String(100), nullable=False)
    content = db.Column(db.Text, nullable=False)
    date_created = db.Column(db.DateTime, default=datetime.now)

    def to_dict(self):
        return {
            "id": self.id,
            "title": self.title,
            "content": self.content,
            "date_created": self.date_created.isoformat(),
        }


@app.route("/notes", methods=["POST"])
def add_note():
    data = request.get_json()
    new_note = Note(title=data["title"], content=data["content"])
    db.session.add(new_note)
    db.session.commit()
    return jsonify(new_note.to_dict()), 201


@app.route("/notes", methods=["GET"])
def get_notes():
    notes = Note.query.order_by(Note.date_created.desc()).all()
    return jsonify([note.to_dict() for note in notes])


@app.route("/notes/<int:id>", methods=["GET"])
def get_note(id):
    note = Note.query.get_or_404(id)
    return jsonify(note.to_dict())


@app.route("/notes/<int:id>", methods=["PUT"])
def update_note(id):
    note = Note.query.get_or_404(id)
    data = request.get_json()
    note.title = data["title"]
    note.content = data["content"]
    db.session.commit()
    return jsonify(note.to_dict())


@app.route("/notes/<int:id>", methods=["DELETE"])
def delete_note(id):
    note = Note.query.get_or_404(id)
    db.session.delete(note)
    db.session.commit()
    return jsonify({"message": "Note deleted successfully"})


if __name__ == "__main__":
    with app.app_context():
        db.create_all()
    app.run(host="0.0.0.0", port=5000, debug=True)
