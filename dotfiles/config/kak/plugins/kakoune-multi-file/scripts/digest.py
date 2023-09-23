from hashlib import sha1
from base64 import urlsafe_b64encode


def digest(lines):
    hash = sha1()
    for line in lines:
        hash.update(line.encode("utf8"))
    return urlsafe_b64encode(hash.digest()).decode("utf8")[:4]
