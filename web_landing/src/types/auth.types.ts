export type UserRole = 'USER' | 'ADMIN';

export interface User {
  id: string;
  email: string;
  fullName: string | null;
  phone: string | null;
  gender: string | null;
  birthDate: string | null;
  role: UserRole;
  avatarUrl: string | null;
  googleId: string | null;
  points: number;
  rank: string;
  createdAt: string;
  updatedAt: string;
}

export interface AuthResponse {
  user: User;
  accessToken: string;
  refreshToken: string;
}

export interface ApiResponse<T> {
  success: boolean;
  message: string;
  data: T;
}

export interface LoginPayload {
  email: string;
  password: string;
}

export interface RegisterPayload {
  email: string;
  password: string;
  fullName: string;
  phone?: string;
}
