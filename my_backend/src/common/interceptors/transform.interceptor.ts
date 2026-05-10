import { CallHandler, ExecutionContext, Injectable, NestInterceptor } from '@nestjs/common';
import { Observable } from 'rxjs';
import { map } from 'rxjs/operators';

export interface Response<T> {
  success: boolean;
  message: string;
  data: T;
}

@Injectable()
export class TransformInterceptor<T> implements NestInterceptor<T, Response<T>> {
  intercept(context: ExecutionContext, next: CallHandler): Observable<Response<T>> {
    return next.handle().pipe(
      map((res) => {
        // Nếu response đã có sẵn format thì giữ nguyên, ngược lại thì bọc vào format chuẩn
        if (res && typeof res === 'object' && 'success' in res && 'message' in res) {
          return res;
        }
        return {
          success: true,
          message: 'Thành công',
          data: res,
        };
      }),
    );
  }
}
