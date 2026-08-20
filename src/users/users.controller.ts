import {
  Body,
  Controller,
  Get,
  NotFoundException,
  Param,
  ParseIntPipe,
  Post,
} from '@nestjs/common';
import { UsersService } from './users.service';
import { CreateUserDto } from './dto/create-user.dto';
import { LoginUserDto } from './dto/login-user.dto';

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

  @Post('login')
  async login(@Body() loginUserDto: LoginUserDto) {
    const user = await this.usersService.login(loginUserDto);

    return {
      success: true,
      message: 'تم تسجيل الدخول بنجاح',
      data: user,
    };
  }

  @Get(':sequentialNumber')
  async findBySequentialNumber(
    @Param('sequentialNumber', ParseIntPipe) sequentialNumber: number,
  ) {
    const user = await this.usersService.findBySequentialNumber(sequentialNumber);

    if (!user) {
      throw new NotFoundException('المستخدم غير موجود بهذا الرقم التسلسلي');
    }

    return {
      success: true,
      data: user,
    };
  }
}