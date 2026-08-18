import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';

import { ValidationPipe } from '@nestjs/common';
async function bootstrap() {
  const app = await NestFactory.create(AppModule);

  app.useGlobalPipes(new ValidationPipe({ transform: true }));
  
  // تفعيل CORS للسماح للواجهة الأمامية بالاتصال
  app.enableCors({
    origin: '*', // في الإنتاج، حدد رابط الواجهة الأمامية بدلاً من *
  });

  const port = process.env.PORT || 3000;
  await app.listen(port);
  console.log(`🚀 Application is running on: http://localhost:${port}`);
}
bootstrap();
