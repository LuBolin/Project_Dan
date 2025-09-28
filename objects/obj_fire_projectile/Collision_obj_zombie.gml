if (other.hp != undefined) other.hp = max(0, other.hp - damage);
instance_destroy(); // bullet disappears on hit