import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { Customer, CustomerDocument } from './customer.schema';
import { CreateCustomerDto } from './dto/create-customer.dto';
import { UpdateCustomerDto } from './dto/update-customer.dto';

@Injectable()
export class CustomersService {
  constructor(
    @InjectModel(Customer.name)
    private customerModel: Model<CustomerDocument>,
  ) {}

  async create(dto: CreateCustomerDto) {
    return await this.customerModel.create(dto);
  }

  async findAll() {
    return await this.customerModel.find();
  }

  async findById(id: string) {
    const customer = await this.customerModel.findById(id);
    if (!customer) throw new NotFoundException('Customer not found');
    return customer;
  }

  async findByName(fullName: string) {
    const customer = await this.customerModel.findOne({ fullName });
    if (!customer) throw new NotFoundException('Customer not found');
    return customer;
  }

  async update(id: string, dto: UpdateCustomerDto) {
    return await this.customerModel.findByIdAndUpdate(id, dto, { new: true });
  }

  async remove(id: string) {
    return await this.customerModel.findByIdAndDelete(id);
  }
}
