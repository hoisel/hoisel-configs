// @ts-nocheck
// Campfire preview — TypeScript/React sample
import { useEffect, useState } from "react";

type Status = "idle" | "loading" | "error";

interface User {
  id: number;
  name: string;
  email?: string;
}

const MAX_RETRIES = 3;
const pattern = /^[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}$/i;

export class UserService {
  private cache = new Map<number, User>();

  async fetchUser(id: number): Promise<User | null> {
    if (this.cache.has(id)) return this.cache.get(id) ?? null;
    for (let attempt = 0; attempt < MAX_RETRIES; attempt++) {
      const res = await fetch(`/api/users/${id}?attempt=${attempt}`);
      if (res.ok) {
        const user = (await res.json()) as User;
        this.cache.set(id, user);
        return user;
      }
    }
    throw new Error(`User ${id} not found`);
  }
}

export function UserCard({ user, compact = false }: { user: User; compact?: boolean }) {
  const [status, setStatus] = useState<Status>("idle");
  const valid = user.email ? pattern.test(user.email) : false;

  useEffect(() => {
    setStatus(valid ? "idle" : "error");
  }, [valid]);

  return (
    <div className="user-card" data-compact={compact}>
      <h2>{user.name}</h2>
      {status === "error" && <span role="alert">Invalid email</span>}
    </div>
  );
}
