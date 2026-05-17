import type { ApiResponse, LoginPayload, AuthResponse, RegisterPayload } from '../types/auth.types'

const BASE_URL = import.meta.env.VITE_API_URL ?? 'http://localhost:3000/api'

async function request<T>(
  path: string,
  options: RequestInit = {}
): Promise<ApiResponse<T>> {
  const token = localStorage.getItem('accessToken')

  const res = await fetch(`${BASE_URL}${path}`, {
    ...options,
    headers: {
      'Content-Type': 'application/json',
      ...(token ? { Authorization: `Bearer ${token}` } : {}),
      ...options.headers,
    },
  })

  const json: ApiResponse<T> = await res.json()

  if (!res.ok) {
    throw new Error(json.message ?? `HTTP ${res.status}`)
  }

  return json
}

export const authApi = {
  login: (payload: LoginPayload) =>
    request<AuthResponse>('/auth/login', {
      method: 'POST',
      body: JSON.stringify(payload),
    }),

  register: (payload: RegisterPayload) =>
    request<AuthResponse>('/auth/register', {
      method: 'POST',
      body: JSON.stringify(payload),
    }),

  profile: () => request<AuthResponse['user']>('/auth/profile'),
}
