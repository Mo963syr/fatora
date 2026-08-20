import { Controller, Post, Body, Get } from '@nestjs/common';
import { UsersService } from './users.service';
import { CreateUserDto } from './dto/create-user.dto';

@Controller('users')
export class UsersController {
  constructor(private readonly usersService: UsersService) {}

  @Post()
  async create(@Body() createUserDto: CreateUserDto) {
    try {
      const user = await this.usersService.create(createUserDto);
      return {
        success: true,
        message: 'تم التسجيل بنجاح',
        data: {
          id: (user._id as any).toString(),
          fullName: user.fullName,
          password: user.password,
          sequentialNumber: user.sequentialNumber, // ✅ إرسال الرقم التسلسلي للواجهة
        },
      };
    } catch (error: unknown) {
      const message =
        error instanceof Error ? error.message : 'حدث خطأ أثناء التسجيل';

      return {
        success: false,
        message: 'حدث خطأ أثناء التسجيل. تأكد من أن رقم الهاتف غير مكرر',
        error: message,
      };
    }
  }

  @Get()
  async findAll() {
    return this.usersService.findAll();
  }
}