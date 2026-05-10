import { createParamDecorator, ExecutionContext } from '@nestjs/common';

// Lấy thông tin user từ request (sau khi đã đi qua JwtAuthGuard)
export const CurrentUser = createParamDecorator(
  (data: unknown, ctx: ExecutionContext) => {
    const request = ctx.switchToHttp().getRequest();
    return request.user;
  },
);
