import os

ADMIN_IDS: list[int] = [377424247, 696767499]

import os
ADMIN_PASSWORD = os.environ.get("ADMIN_PASSWORD", "talk2learn_admin_2025")

BASE_DIR = os.path.dirname(os.path.abspath(__file__))
MINI_DIR  = os.path.join(BASE_DIR, "..", "mini", "static")
WEB_DIR   = os.path.join(BASE_DIR, "..", "web")
AUDIO_DIR = os.path.join(MINI_DIR, "audio")
