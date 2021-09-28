from flask_sqlalchemy import SQLAlchemy

DB = SQLAlchemy()

# PuzzleTable are the scraped Sudoku Puzzles.


class PuzzleTable(DB.Model):
    id = DB.Column(DB.Integer, primary_key=True)
    sudoku = DB.Column(DB.String(200), nullable=False)
    solution = DB.Column(DB.String(200), nullable=False)
    level = DB.Column(DB.String(200), nullable=False)
    people = DB.Column(DB.Integer, nullable=False)
    avg_time = DB.Column(DB.String(500), nullable=False)
    sudoku_hash = DB.Column(DB.String(100), nullable=False)


# A database unifying records across Puzzle ID, S3 URLs for processed
# sudoku cells, and what the model predicted their values to be.
# This table will be critical for future continual learning of the model,
# once a validator is built to confirm each predicted digit is accurate.
class ModelTrainer(DB.Model):
    id = DB.Column(DB.Integer, primary_key=True)
    sudoku_hash = DB.Column(DB.String(200), nullable=False)
    procesed_puzzle_url = DB.Column(DB.String(200), nullable=False)
    cell_url = DB.Column(DB.String(200), nullable=False)
    numpy_array = DB.Column(DB.String(5000), nullable=False)
    predicted_value = DB.Column(DB.String, nullable=False)
